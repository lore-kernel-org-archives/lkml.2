Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1FGNcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:32:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:54303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FGNcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:32:18 -0400
Date: Tue, 7 Jun 2011 15:32:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Simon Wood <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcin Tolysz <tolysz@gmail.com>
Subject: Re: [PATCH 1/2] sony_ff_hid_descriptor
In-Reply-To: <20110601214924.36ec42ad.ospite@studenti.unina.it>
Message-ID: <alpine.LNX.2.00.1106071531330.22872@pobox.suse.cz>
References: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com> <1306145999-15643-1-git-send-email-simon@mungewell.org> <20110601214924.36ec42ad.ospite@studenti.unina.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Antonio Ospite wrote:

> On Mon, 23 May 2011 03:19:58 -0700
> Simon Wood <simon@mungewell.org> wrote:
> 
> > This patch modifies the HID descriptor to allow the reporting of
> > the accelerometers and gyro via a joystick axis.
> 
> I am going to test it tomorrow, but for now I notice that the
> Signed-off-by is missing. Wait for the test before resending tho.
> 
> Plus, the short commit message can be improved a little bit, and the
> long commit message could use the classic imperative form used in kernel
> commit messages: "Modify the HID descriptor to...", but these are just
> suggestions.
> 
> Same comments for patch 2/2.

Antonio,

thanks for the (valid) comments.

What was the result of your testing of the patches, please?

Simon, would you please, once Antionio adds his Tested-by:, to resend with 
proper authorship and Signed-off-by? 

Thanks,

-- 
Jiri Kosina
SUSE Labs
