Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab1EBOHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:07:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62512 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab1EBOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:07:06 -0400
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: remove unwanted semicolons
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1304253318-26909-1-git-send-email-namhyung@gmail.com>
Date: Mon, 02 May 2011 10:06:59 -0400
In-Reply-To: <1304253318-26909-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Sun, 1 May 2011 21:35:18 +0900")
Message-ID: <yq1k4e942nw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DBEBA87.014A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Namhyung" == Namhyung Kim <namhyung@gmail.com> writes:

Namhyung> Since those defined functions require additional semicolon
Namhyung> from the caller, they could cause potential syntax errors when
Namhyung> used in if-else statements.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
