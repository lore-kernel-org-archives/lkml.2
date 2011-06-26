Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1FZTzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 15:55:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51655 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab1FZTyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 15:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IhrFp0wsD8gCMeUu0MFdbUUrNyqciugWQj+iko464snhCXE6/k8tot8YPfZFiCtfzH
         72DWAKRKZI3WA3p/ZQjgf+bufEBF+0Y2aqqgvMqlT9jdt3o+4vSinT3A5m/I0J1fGuwh
         E+wo3v6jkDawnUSaOCWCOnOiUzrxgKnOSX4DY=
MIME-Version: 1.0
In-Reply-To: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
Date: Sun, 26 Jun 2011 21:54:37 +0200
Message-ID: <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature sensor.
From: Fubo Chen <fubo.chen@gmail.com>
To: sdevrien@cisco.com
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, guenter.roeck@ericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:40 PM,  <sdevrien@cisco.com> wrote:
> +       } else
> +       if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */

No kernel coder writes like this. Has this ever been run through checkpatch ?

Fubo.
