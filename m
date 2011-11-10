Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab1KJQeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:34:21 -0500
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:63015 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab1KJQeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:34:19 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Date: Thu, 10 Nov 2011 10:33:21 -0600
Subject: Re: [RFC PATCH 04/17] powerpc: Allow multiple machine-check handlers
Thread-Topic: [RFC PATCH 04/17] powerpc: Allow multiple machine-check
 handlers
Thread-Index: AcyfxnZIbhJP8x9LQEmkh2AURCBkHw==
Message-ID: <2806AFF9-4F67-4846-95F6-D4093EA351A5@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
 <1320883635-17194-5-git-send-email-Kyle.D.Moffett@boeing.com>
 <C3C78EA9-9E3D-46AC-94D0-537348DCFC64@kernel.crashing.org>
In-Reply-To: <C3C78EA9-9E3D-46AC-94D0-537348DCFC64@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 10, 2011, at 08:37, Kumar Gala wrote:
> On Nov 9, 2011, at 6:07 PM, Kyle Moffett wrote:
>> 
>> +#if defined(CONFIG_FSL_E500MC) || defined(CONFIG_FSL_E5500)
>> +#ifdef CONFIG_FSL_E500_V1_V2
> 
> doesn't exist yet, so patch is wrong sequence order.

Oops, d'oh.

You are completely correct, thanks for noticing!

I'll fix this for my next submission.

Cheers,
Kyle Moffett
