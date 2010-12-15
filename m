Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0LOTbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:31:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:65387 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0LOTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:31:19 -0500
To: Hugh Dickins <hughd@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ric Wheeler <ricwheeler@gmail.com>,
        Christian Brandt <brandtc@psi5.com>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: swap storage alignment and stride size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4CFFBA7D.6060802@psi5.com> <4CFFE2EA.9040909@gmail.com>
	<yq1d3p486qe.fsf@sermon.lab.mkp.net>
	<alpine.LSU.2.00.1012142038430.13004@tigran.mtv.corp.google.com>
Date: Wed, 15 Dec 2010 14:30:44 -0500
In-Reply-To: <alpine.LSU.2.00.1012142038430.13004@tigran.mtv.corp.google.com>
	(Hugh Dickins's message of "Tue, 14 Dec 2010 20:57:28 -0800 (PST)")
Message-ID: <yq18vzq6dgb.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hugh" == Hugh Dickins <hughd@google.com> writes:

Hugh> (scan_swap_map does try to allocate in 1MB clusters, but they're
Hugh> not written out that way, and there's no attempt to align: if it
Hugh> worked out better for the lower level to require that these 1MB
Hugh> clusters are aligned, we could probably go for that - though the
Hugh> swap header page might then be a nuisance.)

You called it a "header page". Does that imply that it is page sized?
Or will it cause pages written to a 4k-aligned swap device to be
misaligned?

-- 
Martin K. Petersen	Oracle Linux Engineering
