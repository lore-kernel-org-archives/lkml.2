Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0DBB2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:28:44 -0400
Received: from p01c12o142.mxlogic.net ([208.65.145.65]:53068 "EHLO
	p01c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab0DBB2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:28:42 -0400
X-MXL-Hash: 4bb5484a55398b66-f95fd734767a41ae9fd55c09df8cc84c07cd50d4
X-MXL-Hash: 4bb548453955e470-fd284ebc7e8a6f574486761580e6fd7c65c7315f
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: David Miller <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 1 Apr 2010 20:28:33 -0500
Subject: RE: [PATCH] printk.c: remove duplicate const
Thread-Topic: [PATCH] printk.c: remove duplicate const
Thread-Index: AcrSAqKmE3WQKPNjSlOpoerdhfvAvAAAMrqw
Message-ID: <0D753D10438DA54287A00B0270842697636A7E957A@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636A7E956D@AUSP01VMBX24.collaborationhost.net>
 <20100401.182004.197314081.davem@davemloft.net>
In-Reply-To: <20100401.182004.197314081.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040101)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=2fwc1ImzvEAA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i00gxMtYAAAA:8 a=PmV]
X-AnalysisOut: [s3lXHxUH0fQIQyC8A:9 a=4VopgE3nyuSYFTOte4wweZQb2tsA:4 a=Cju]
X-AnalysisOut: [IK1q_8ugA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 01, 2010 6:20 PM, David Miller wrote:
> From: H Hartley Sweeten <hartleys@visionengravers.com>
> Date: Thu, 1 Apr 2010 20:13:27 -0500
> 
>> Noticed during a sparse build.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> Isn't it intentional?  The two consts mark different aspects
> of the declaration const, both the pointers as well as the
> contents pointed to.

Isn't that a C++ and not a C feature?

If it is valid in C then I guess the sparse people should be informed.

Regards,
Hartley