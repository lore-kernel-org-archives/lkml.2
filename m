Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0ILT6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:58:40 -0400
Received: from smtp129.mail.ukl.yahoo.com ([77.238.184.60]:42308 "HELO
	smtp129.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753003Ab0ILT6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:58:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=FdBq8x48aHr/sRrcJisxtuBaAUf1ktdqbMrCOlUz11S3D15Rmoz+tbFjHHK5Z62oWWAaSfs83ZAIBLPK1TIttltyzU87+wx+JDoH1Tx78Hh3w8YMidrIAmla9nCoabrFwXrwKhztAstMcxdHAwa/2XyIcigvtGpeA9BAlm0yXxU=  ;
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
X-YMail-OSG: 3UtNc6gVM1k6riggvIgT.YsJV0jMjv101WNLITpadUNTDef
 _RS9Vc40NddJENbwS49tYvE1.ir6cxj73aVCOKMZq0qw.rFC.wiJqK2kJTED
 .pkfdaPzYdnZkLlDavaW5iuWJy.rKuq_0uzejEV5Tk2c2JxN2nXGegm7W.u1
 SSlln_T0f6bzQ2F9iAg38KMe6hAcOm5oNgwV9kUrXT.sKFV2UrDh3gwrbJmW
 C1CcI14ksKvD3_8wgJSYVX29.o7d6NSKCVAEEYCtyAOV3eCH5rx4mQM1G80Z
 8Yg--
X-Yahoo-Newman-Property: ymail-3
From: Marek Lindner <lindner_marek@yahoo.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: [PATCH] staging: batman-adv: check kmalloc() return value
Date: Sun, 12 Sep 2010 21:57:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Lunn <andrew@lunn.ch>, Sven Eckelmann <sven.eckelmann@gmx.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andreas Langer <an.langer@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1284317791-4744-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284317791-4744-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009122157.40497.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 September 2010 20:56:26 Vasiliy Kulikov wrote:
> kmalloc() may fail, if so drop current packet.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Looks good to me. Added this patch to our repos.

Thanks,
Marek
