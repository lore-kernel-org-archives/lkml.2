Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab0FREex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:34:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51745 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0FREew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rLHi18gsWgGS1IgmPAW6Gjk6CtvNNhshiilX2MpGfpqf+ANYYtztvFK+Azlwu0pppJ
         /uERzIViCYKDuLFeuIF5S8iRTXoQuIrhi/6GFeayu+yg2JjCj4DuP1SRfk7u6mL08Nvd
         oY1oEB7CE1yriV/SojE7xUs1TV6ydzBCducxw=
MIME-Version: 1.0
In-Reply-To: <201006041226.o54CQH2V017366@amcc.com>
References: <201006041226.o54CQH2V017366@amcc.com>
Date: Fri, 18 Jun 2010 13:34:51 +0900
Message-ID: <AANLkTimyBRz2JI7rwkT-1SMVYMc3Ne_bL_NGk_U1Deia@mail.gmail.com>
Subject: Re: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 9:26 PM, Rupjyoti Sarmah <rsarmah@amcc.com> wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.

Doesn't this DWC sata IP provide AHCI ? Just curious.
