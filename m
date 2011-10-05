Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882Ab1JEPW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:22:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38866 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934453Ab1JEPWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:22:55 -0400
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
In-Reply-To: <1317798564.3099.12.camel@edumazet-laptop>
References: <20111001000856.DD623081@kernel>
	 <20111001000900.BD9248B8@kernel>
	 <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
	 <1317798564.3099.12.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 08:22:35 -0700
Message-ID: <1317828155.7842.73.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 09:09 +0200, Eric Dumazet wrote:
> By the way, "pagesize=4KiB" are just noise if you ask me, thats the
> default PAGE_SIZE. This also breaks old scripts :)

How does it break old scripts?

-- Dave

