Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1HVIt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:49:57 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:45389 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab1HVIty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:49:54 -0400
Date: Mon, 22 Aug 2011 10:50:03 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] [media] gspca: Use current logging styles
Message-ID: <20110822105003.0002ef3c@tele>
In-Reply-To: <9927bff9b5f212dcbe867a9f882e53ed80bd9a0f.1313966090.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
	<9927bff9b5f212dcbe867a9f882e53ed80bd9a0f.1313966090.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Aug 2011 15:56:57 -0700
Joe Perches <joe@perches.com> wrote:

> Add pr_fmt.
> Convert usb style logging macros to pr_<level>.
> Remove now unused old usb style logging macros.

Hi Joe,

Sorry, but I do not see the advantages of your patch.

For gspca, the source files are bigger, and the only visible change is
the display of the real module name instead of the name defined by hand
(this change may have been done just in gspca.h).

Also, I think that defining 'pr_fmt' in each source file is not a good
idea...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
