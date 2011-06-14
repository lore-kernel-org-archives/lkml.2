Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1FNRzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:55:36 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:57650 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab1FNRze convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:55:34 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        Jie Yang <jie.yang@atheros.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>,
        Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>,
        Divy Le Ray <divy@chelsio.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        "linux-driver@qlogic.com" <linux-driver@qlogic.com>,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        Jon Mason <jdmason@kudzu.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Steve Hodgson <shodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Daniele Venzano <venza@brownhat.org>,
        David Dillow <dave@thedillows.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 14 Jun 2011 19:53:56 +0200
Subject: RE: [PATCH net-next 2/2] drivers/net: Remove casts of void *
Thread-Topic: [PATCH net-next 2/2] drivers/net: Remove casts of void *
Thread-Index: AcwqR/HBI/c+oGhcS+2I2Eianqc03QAc1uow
Message-ID: <81C3A93C17462B4BBD7E272753C105791A64A8E554@EXDCVYMBSTM005.EQ1STM.local>
References: <cover.1308024069.git.joe@perches.com>
 <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
In-Reply-To: <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Joe Perches]:
> Unnecessary casts of void * clutter the code.
>--- a/drivers/net/caif/caif_shmcore.c
>+++ b/drivers/net/caif/caif_shmcore.c
>@@ -134,7 +134,7 @@ int caif_shmdrv_rx_cb(u32 mbx_msg, void *priv)
> 	u32 avail_emptybuff = 0;
> 	unsigned long flags = 0;
> 
>-	pshm_drv = (struct shmdrv_layer *)priv;
>+	pshm_drv = priv;
> 


CAIF parts looks good to me,

Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
