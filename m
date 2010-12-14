Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab0LNUBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:01:46 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47481 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921Ab0LNUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:01:44 -0500
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Christian Brandt <brandtc@psi5.com>, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: swap storage alignment and stride size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4CFFBA7D.6060802@psi5.com> <4CFFE2EA.9040909@gmail.com>
Date: Tue, 14 Dec 2010 15:00:41 -0500
In-Reply-To: <4CFFE2EA.9040909@gmail.com> (Ric Wheeler's message of "Wed, 08
	Dec 2010 14:56:26 -0500")
Message-ID: <yq1d3p486qe.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ric" == Ric Wheeler <ricwheeler@gmail.com> writes:

Sorry, I've been away for a couple of weeks.

Ric> There has been a lot of work on alignment, Martin Petersen lead
Ric> most of that and is probably the best one to ping.

With modern tooling we should align the partition or DM device correctly
so the swap starts on a properly aligned boundary. But I don't think
anybody has looked into hooking the swap stuff up with the I/O
topology. I'm also not sure the swap code is flexible enough to deal
with units that are bigger than page size.

Hugh?

-- 
Martin K. Petersen	Oracle Linux Engineering
