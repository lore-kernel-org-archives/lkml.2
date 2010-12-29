Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0L2Uy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:54:57 -0500
Received: from nm2.bullet.mail.ac4.yahoo.com ([98.139.52.199]:38761 "HELO
	nm2.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752585Ab0L2Uyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:54:54 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Dec 2010 15:54:54 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 715751.25193.bm@omp1028.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=47MVU2TfORIweWJAEnDwMAmtaloKJGsUxuxfKq5xImkiqVvYQjF5UhLdsdu6Q8SiMlDbuKmiKBZXwiMXan4jEXkSoN7NrQKNb4NEaa+NSh86T1n6BsBhZAvLf+YdbE5k1WR4D3Z9d3P+ba+/dHSdKo5FrO/NB3j2N9LGwZZ5KWk=;
Message-ID: <446161.64736.qm@web56607.mail.re3.yahoo.com>
X-YMail-OSG: Qr3_16QVM1lHQYVDbQEUbWLQ_yX69J65RaMkWtFAcycwQmg
 h.z.lniFf7xg4UZrVVbv.hXRlCFMY2fJKmY3gFLkmAAwhNY0bjxKJ.QLRV0c
 lT1ZlPfH.YnzM84a_iOXpc_RiMebqoZ6vYjacjMu02ZEVW9MMscH2w3i_jBo
 GSYfwGg99L5KQK2Pb_KRvPbT9WE0Vce28TFGWTlF_LYfazB6ELR.otUFM2AB
 OUMJjZobhMNyvWYaSB4cTOu2h74g2Vex_HWRI9CXq7Xx3oqiCaVNI7HOLT1c
 ky.YnBTKScC.vOyloQy7kQNuELqS0h7GY4uYf9gEZhPVyJQmRgbMthxBr0SM
 IWiZL5yOrGuwKz5_B09TMIxEFbJbM4tZz59hvI60BMRkYZIoqm4Iw_gi2cEi
 3tTOfVIKu6z1n
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Wed, 29 Dec 2010 12:48:37 -0800 (PST)
From: andrei radulescu-banu <iubica2@yahoo.com>
Subject: Is PCI express Gen 2 supported by Linux?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've scanned the PCI information under Documentation/PCI in the source tree, but could not find this information. I am not sure if PCIe gen 2 requires special software support in the PCI layer, or if the hardware hides any PCIe version differences from the Linux PCI driver.

Thanks,
Andrei

PS. Please cc me on the response...


      
