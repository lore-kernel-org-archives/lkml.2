Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889Ab1JEPcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:32:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46160 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934549Ab1JEPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:32:16 -0400
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        James.Bottomley@hansenpartnership.com, hpa@zytor.com
In-Reply-To: <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel>
	 <20111001000900.BD9248B8@kernel>
	 <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 08:21:33 -0700
Message-ID: <1317828093.7842.72.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11100515-7282-0000-0000-000002244AA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 23:50 -0700, David Rientjes wrote:
> That way, 1G pages would just show pagesize=1073741824.  I don't think 
> that's too long and is much easier to parse systematically. 

OK, I'll switch it back.

-- Dave

