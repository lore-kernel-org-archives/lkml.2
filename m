Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1JNR5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:57:06 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28799 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751091Ab1JNR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:57:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ShBY.O0VM1kCgdh7drbGFl96B1k_CSApxPHPIRDQIEI01No
 5iL0Ed03MFlWUTEUJYPARMlgOoB253qKtO_SBZm.dx5qq5H.JRx7PijMfDXY
 5GeYRsHNhN2ZnU3k4Hrz1xyvxefSJ5eIiMacIBSBADapiSqhzl7Ocy.RHmCH
 X08tSVK0QPsL97X8My_Csb7z2cRIxeU8Rihb8IMJkOZ9j1QYOG9yP7UGerdp
 h1PHhqfkDyEOByTKYe9Xpt5wO3T1A5KpJcNpLI5uWiy0QWisG52JzX4Gs2WO
 116D_6pLqfcJ3Hm27lWbB4wuVFdwgQ5OYPL4yNQ4QGcgTc6TRkitXh_Kv74p
 NLCkXA4UIFIMGWkGj9PE6XJx0vkmf2i7Z6gSJ2XxHAS4Ejgck01CcpTQ0IYi
 _Y4slT5hgX5wj6qsHtHK2TS2Gm.VwfWmB1Y0-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 14 Oct 2011 12:57:01 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [slabinfo PATCH] Fix off-by-one after readlink() call
In-Reply-To: <4E9870A8.2010905@intra2net.com>
Message-ID: <alpine.DEB.2.00.1110141256440.11464@router.home>
References: <4E9869B4.6080702@intra2net.com> <alpine.DEB.2.00.1110141214270.6411@router.home> <4E9870A8.2010905@intra2net.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Thomas Jarosch wrote:

> Reducing the buffer size by one is easier IMHO.

Ok.

Acked-by: Christoph Lameter <cl@gentwo.org>

