Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0EFHZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:25:30 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:4474 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121Ab0EFHZ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:25:26 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Scott Feldman <scofeldm@cisco.com>, Arnd Bergmann <arnd@arndb.de>,
       Dmitry Torokhov <dtor@vmware.com>
CC: Christoph Hellwig <hch@infradead.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       Pankaj Thakkar <pthakkar@vmware.com>
Date: Thu, 6 May 2010 00:25:24 -0700
Subject: RE: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Thread-Topic: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Thread-Index: AcrsnXZHfCzcBb5GR+COtROFMlz8vwAAIsdgAAiX7GgACwVbwA==
Message-ID: <89E2752CFA8EC044846EB8499819134102AF2D23E6@EXCH-MBX-4.vmware.com>
References: <89E2752CFA8EC044846EB8499819134102AF2896F5@EXCH-MBX-4.vmware.com>
 <C807719A.2E910%scofeldm@cisco.com>
In-Reply-To: <C807719A.2E910%scofeldm@cisco.com>
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



> -----Original Message-----
> From: Scott Feldman [mailto:scofeldm@cisco.com]
> Sent: Wednesday, May 05, 2010 7:04 PM
> To: Shreyas Bhatewara; Arnd Bergmann; Dmitry Torokhov
> Cc: Christoph Hellwig; pv-drivers@vmware.com; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; virtualization@lists.linux-
> foundation.org; Pankaj Thakkar
> Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for
> vmxnet3
> 
> On 5/5/10 10:29 AM, "Dmitry Torokhov" <dtor@vmware.com> wrote:
> 
> > It would not be a binary blob but software properly released under
> GPL.
> > The current plan is for the shell to enforce GPL requirement on the
> > plugin code, similar to what module loaded does for regular kernel
> > modules.
> 
> On 5/5/10 3:05 PM, "Shreyas Bhatewara" <sbhatewara@vmware.com> wrote:
> 
> > The plugin image is not linked against Linux kernel. It is OS
> agnostic infact
> > (Eg. same plugin works for Linux and Windows VMs)
> 
> Are there any issues with injecting the GPL-licensed plug-in into the
> Windows vmxnet3 NDIS driver?
> 
> -scott

