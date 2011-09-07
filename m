Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1IGRuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:50:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24049 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1IGRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:50:06 -0400
Date: Wed, 7 Sep 2011 13:48:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hch@infradead.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, jbeulich@novell.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110907174832.GN32190@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E67AE86.0023:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Christoph,

I was wondering what you think is the proper way of implementing a
backend to support the 'barrier' type requests? We have this issue were
there are 2.6.36 type guests that still use barriers and we would like
to support them properly. But in 3.0 there are no barriers - hence
the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?

Or is there some other things that we should take in consideration?

Thanks!
