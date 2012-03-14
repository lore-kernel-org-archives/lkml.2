Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2CNPI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab2CNPI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:08:57 -0400
Date: Wed, 14 Mar 2012 10:23:01 -0400
From: Dave Jones <davej@redhat.com>
To: "M. Mohan Kumar" <mohan@in.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] 9p: BUG: unable to handle kernel paging request
 at ffff880035698000
Message-ID: <20120314142301.GA2371@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"M. Mohan Kumar" <mohan@in.ibm.com>,
	Sasha Levin <levinsasha928@gmail.com>, ericvh@gmail.com,
	rminnich@sandia.gov, lucho@ionkov.net,
	v9fs-developer@lists.sourceforge.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1329841429.10124.38.camel@lappy>
 <4F602E2E.8030008@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F602E2E.8030008@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:05:42AM +0530, M. Mohan Kumar wrote:
 > On 02/21/2012 09:53 PM, Sasha Levin wrote:
 > > Hi,
 > >
 > > I was using the KVM tool for tests with trinity on top of a virtio-9p filesystem, and started seeing the BUGs below when I've put some pressure on the 9p fs (not much, just started writing the logs from trinity to a 9p fs).
 > Hi Sasha,
 > 
 > You mentioned about testing with trinity, Where can I find this trinity 
 > ? Is is some test suite ?

git://git.codemonkey.org.uk/trinity

	Dave

