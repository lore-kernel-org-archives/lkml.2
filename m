Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0F2BgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:36:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61884 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0F2BgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=BadEbC8Hnj0f9KhzY9N4uTYpsWHB8FuNrFm0tHvQ2DrDhc5n3lzluQpggU+xm7Qpa9
         WC1ZfPuDOkqHxY+YRBYuN1+bpgMWNx/V5eyBRC9O2BRBf1QJnGZ4gyEcg8OyC9cah23n
         qOAXfO2UatnU9Q9ek/zmZuhGVoMDO4nBrM1G4=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Subject: Re: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>
Date: Tue, 29 Jun 2010 03:33:50 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, linuxppc-dev@ozlabs.org
References: <201006041226.o54CQH2V017366@amcc.com>
In-Reply-To: <201006041226.o54CQH2V017366@amcc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006290333.50673.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 4. června 2010 14:26:17 Rupjyoti Sarmah napsal(a):
> This patch enables the on-chip DWC SATA controller of the AppliedMicro
> processor 460EX.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>
> Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
> 

--SNIP--

> +		dev_err(ap->dev, "%s: Command not pending cmd_issued=%d "
> +			"(tag=%d) DMA NOT started\n", __func__,
> +			hsdevp->cmd_issued[tag], tag);

Just a nitpick, but don't break strings if possible.
