Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0CQVK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:10:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49275 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CQVKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:10:25 -0400
In-Reply-To: <20100317154501.GA5244@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       Paul Moore <paul.moore@hp.com>, sri@linux.vnet.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH RFC] tun: add ioctl to modify vnet header size
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF526018DA.E6922CE9-ON882576E9.0073CB01-882576E9.007449E0@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 17 Mar 2010 14:10:11 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 8.5.1HF41 | October 22, 2009) at
 03/17/2010 15:10:12,
	Serialize complete at 03/17/2010 15:10:12
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't we enforce a maximum too? Esp. if overflow/underflow
will break any of the checks when it's used.

                                +-DLS

