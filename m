Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab0FBWfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:35:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39837 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab0FBWfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=unffhk64rJKTrldXDzQYwqCHwfVBffkI34e7YEK7mDFNNLrORv8inZ0gvWPs5tJJwr
         lHNey6EWoVX52dQEOjKiySryrlWR1kmpKXTZsQffnzrlSheeGNSvV/Q1XMz/ny4s435E
         ayYX6sJ/nBizEzvqoZRNnZA0AAxvoZ5zxUqxo=
MIME-Version: 1.0
In-Reply-To: <kqld06dbv2ektmqfadr8l3dqtmm6hler2c@4ax.com>
References: <kqld06dbv2ektmqfadr8l3dqtmm6hler2c@4ax.com>
Date: Wed, 2 Jun 2010 18:35:45 -0400
X-Google-Sender-Auth: 3wJuc30jx9EQvCsBHw2sZgrFrMQ
Message-ID: <AANLkTimaYtD9qzPYmABVg3clxE6KYeo5bgI8Qp_IBr14@mail.gmail.com>
Subject: Re: How to stop kernel rebooting during startup?
From: Bob Copeland <me@bobcopeland.com>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 6:20 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
> which worked fine on slackware64-13.0, has this behaviour on slack-
> ware64-13.1.  Because I cannot read the screen before reboot, no idea
> where to look next, or what is actually happening.

Maybe try CONFIG_BOOT_PRINTK_DELAY to see the message?

-- 
Bob Copeland %% www.bobcopeland.com
