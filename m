Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0FNRJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:09:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50669 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0FNRJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:09:41 -0400
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100614165853.GW5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>
	 <1276214852.6437.1427.camel@nimitz>
	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>
	 <20100614084810.GT5191@balbir.in.ibm.com>
	 <1276528376.6437.7176.camel@nimitz>
	 <20100614165853.GW5191@balbir.in.ibm.com>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 10:09:31 -0700
Message-Id: <1276535371.6437.7417.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 22:28 +0530, Balbir Singh wrote:
> If you've got duplicate pages and you know
> that they are duplicated and can be retrieved at a lower cost, why
> wouldn't we go after them first?

I agree with this in theory.  But, the guest lacks the information about
what is truly duplicated and what the costs are for itself and/or the
host to recreate it.  "Unmapped page cache" may be the best proxy that
we have at the moment for "easy to recreate", but I think it's still too
poor a match to make these patches useful.

-- Dave

