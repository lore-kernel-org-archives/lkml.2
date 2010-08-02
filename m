Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0HBPgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:36:39 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:36283 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751284Ab0HBPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:36:37 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hNHesaEVM1kYzu.saG1xN3pjLkZ2uaHQKtB22wOdROX7xVl
 KM9yPGT91LFtZiykDAPpzg1kJg24CEH8DReMDYfQVdHnZNWWOAU1Jpd9dZgY
 qc8w9I3XuDt2WY4c5Pa1EdefTUrLEtJWvysJXF53b60dwrNjzzreyencoX0w
 8xdWLHglzQGTLrDs4zFtHwLb52Ro99fzekBh887bl5MuQpn2XajSlhYrtfzC
 pD4LrekD90ReelLothZfvYE3u4HbU8AISe0UIz9C1mvEnhXphaoj6
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 2 Aug 2010 10:36:33 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 07/19] slub: Allow removal of slab caches during boot
In-Reply-To: <4C53EFBA.4090900@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1008021036210.18455@router.home>
References: <20100709190706.938177313@quilx.com>  <20100709190853.770833931@quilx.com>  <alpine.DEB.2.00.1007141647340.29110@chino.kir.corp.google.com> <1279498030.10390.1760.camel@pasglop> <alpine.DEB.2.00.1007191058220.29361@router.home>
 <4C53EFBA.4090900@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010, Pekka Enberg wrote:

> Christoph, Ben, should I queue this up for 2.6.36?

Yes.
