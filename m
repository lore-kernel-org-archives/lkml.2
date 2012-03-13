Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab2CMJn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:43:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:30141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760240Ab2CMJns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117187578"
From: "Ryan Ware" <ware@linux.intel.com>
To: "'James Morris'" <jmorris@namei.org>,
        "Mimi Zohar" <zohar@linux.vnet.ibm.com>
Cc: <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "David Safford" <safford@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com> <alpine.LRH.2.02.1203072057350.29863@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1203072057350.29863@tundra.namei.org>
Subject: RE: [PATCH v2 00/11] ima: appraisal extension
Date: Tue, 13 Mar 2012 11:42:42 +0200
Message-ID: <03e301cd00fd$a590ab60$f0b20220$@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHM99/4TdGVm9sbz0CkvgUUxxqyW5ZfKryAgAjgWdA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-security-module-owner@vger.kernel.org [mailto:linux-security-
> module-owner@vger.kernel.org] On Behalf Of James Morris
> Sent: Wednesday, March 07, 2012 12:08 PM
> To: Mimi Zohar
> Cc: linux-security-module@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-fsdevel@vger.kernel.org; David Safford; Kasatkin, Dmitry
> Subject: Re: [PATCH v2 00/11] ima: appraisal extension
> 
> On Thu, 1 Mar 2012, Mimi Zohar wrote:
> 
> > IMA currently maintains an integrity measurement list used to assert
> > the integrity of the running system to a third party.  The
> > IMA-appraisal extension adds local integrity validation and
> > enforcement of the measurement against a "good" value stored as an
> > extended attribute 'security.ima'.
> 
> Do you know if any distros are planning on integrating EVM/IMA?
> 
> What about Tizen ?  The now defunct MeeGo project weas previously the main
> intended user.

James, we are intending on incorporating this into Tizen for product
verticals that require the additional integrity protections these features
provide.

Ryan

