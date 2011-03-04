Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab1CDH7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:59:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35554 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab1CDH7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:59:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bVs094EA+4LWOqMQSO1szbEBqiIix7D3uyKUQhQ3Auo+bRaInx+dyfJ+ZrV89WO/eS
         DVvynAFXHgsibEXGggEqGiYBvN9dUVRh4/NLccu9FP5oamFHlrPJ9uyFJbdIc20eeEkw
         ULeo+ZLGxADIqWYpGtTSJhnJjjVyXbrOLXwCk=
Date: Thu, 3 Mar 2011 23:59:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: dudl@cypress.com, rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@google.com, micahc@google.com,
        chromium-os-reviews@chromium.org, vb+kernel@google.com,
        msb@chromium.org, olofj@chromium.org
Subject: Re: Add new i2c-based input mouse driver into input subsystem for
 Cypress trackpad devices. (issue6626009)
Message-ID: <20110304075921.GA4323@core.coreip.homeip.net>
References: <bcaec52c66a51e1eda049da36252@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcaec52c66a51e1eda049da36252@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Fri, Mar 04, 2011 at 07:49:18AM +0000, dudl@cypress.com wrote:
> Reviewers: rubini_ipvvis.unipv.it, dmitry.torokhov_gmail.com,
> linux-input_vger.kernel.org, linux-kernel_vger.kernel.org, olofj_g,
> Micah C, dudl,
> 
> Description:
> Add new i2c-based input mouse driver into input subsystem for
> Cypress trackpad
> devices.
> 
> Through this new added driver,
> Cypress i2c-based trackpad devices will be supported in Linux based system
> which are developed based on Cypress self-designed PSOC chipset.
> This driver reads trackpad data using i2c interfaces and report cursor
> moving data and gesture combined keys to input subsystem.
> 
> 
> Change-Id: I108ad1505f3d34ab24658921a772e937940a1b88
> Signed-off-by: Du, Dudley <dudl@cypress.com>
> 
> BUG=None
> TEST=Work fine on ARM tegra2 saeboard and kaen platfrom
> 
> Please review this at http://codereview.chromium.org/6626009/
> 

Please post your patches in unified diff format on the input mainling
list (linux-input@vger.kernel.org, and please also CC me) - this is
common (and only) way for mainline patch submission.

Thank you.

-- 
Dmitry
