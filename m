Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2IFOqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:46:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:31745 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756176Ab2IFOqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:46:49 -0400
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: Matt Fleming <matt.fleming@intel.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@Dell.com>,
        Peter Jones <pjones@redhat.com>
In-Reply-To: <5048B52A.6000602@canonical.com>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <1346941120.4244.82.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5048B1E8.1020904@canonical.com>
	 <1346941851.4244.87.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5048B52A.6000602@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 06 Sep 2012 15:46:38 +0100
Message-ID: <1346942798.4244.91.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 22:37 +0800, Jeremy Kerr wrote:
> That's correct, but we can't use unlink to delete a secure variable, we 
> need to do a write instead, in order to provide the authentication 
> descriptor.

Ah, duh. Thanks for clearing that up.

