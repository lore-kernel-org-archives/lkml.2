Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0HKUmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:42:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357Ab0HKUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:42:29 -0400
Date: Wed, 11 Aug 2010 13:41:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] matroxfb: fix incorrect use of memcpy_toio()
Message-Id: <20100811134136.c53f8eba.akpm@linux-foundation.org>
In-Reply-To: <201008112227.44990.linux@rainbow-software.org>
References: <201008112227.44990.linux@rainbow-software.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 22:27:42 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> Fix incorrect use of memcpy_toio() in matroxfb that broke in 2.6.34 on x86.
> 

Thanks.

What was incorrect about it?  And what is the user-visible effect of
this regression?

