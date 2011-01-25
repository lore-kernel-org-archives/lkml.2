Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1AYOoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:44:00 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:43943 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333Ab1AYOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:43:59 -0500
Date: Tue, 25 Jan 2011 09:43:53 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: Regression, bisected: NFSv3 BUG when quitting vim in 2.6.38-rc2+.
Message-ID: <20110125144353.GA3650@elliptictech.com>
References: <20110124223442.GA3831@elliptictech.com>
 <6D769E5D-F4FA-4E29-AC00-C2B000561ADF@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6D769E5D-F4FA-4E29-AC00-C2B000561ADF@oracle.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-24 17:53 -0500, Chuck Lever wrote:
> I think we just fixed this one.  See:
> 
>   http://marc.info/?l=linux-nfs&m=129555110430091&w=2

Yeah, that seems to fix it.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
