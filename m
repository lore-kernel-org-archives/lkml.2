Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1KVRky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:40:54 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:38624 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754867Ab1KVRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:40:53 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: A_oEQRIVM1m3WiFOAPasQRu96yUcGGQPZoKVLTtS0hIGcva
 E3pOBAdbX8Av7y7Uf4rYclQdVfJhE266_w.BuiZ2rCUl8bWN50gAE1_PUw6A
 3Ncow0cWW5XaC.he498is5Q8wXcN94U8gn7ku.LAJq2iqLWh1lZIj2N5KbDT
 B4VEky1QV9fw7fvhvnzreX1qc1hy18wozgv1KccNjKQ_dBZi1e3DbSSb.Uek
 vcgjl.eTJLLmjvhot2E3hWmzGQ8Nu..u3G3Ulcfn843EnyjqfSp1xDcZok55
 P8rs1sfF01zBv93GVgwCi_R1WnN9s_f1qJ.n1TOTNwWW.BQuAy8xGhLahqkc
 IJBWQ4emMns0VSRFJuODKXX1GMKUbbAoi_7QZUFRbFDP_cmBADId3LIWY9Gc
 UjdlqJ914yT8CexdBVVti
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 11:40:48 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: slub: Lockout validation scans during freeing of object
In-Reply-To: <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111221139240.28197@router.home>
References: <alpine.DEB.2.00.1111221033350.28197@router.home>  <alpine.DEB.2.00.1111221040300.28197@router.home>  <alpine.DEB.2.00.1111221052130.28197@router.home> <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> This seems better, but I still have some warnings :

Trying to reproduce with a kernel configured to do preempt. This is
actually quite interesting since its always off by 1.
