Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2EJP4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:56:39 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:39185 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755160Ab2EJP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:56:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: u3bXjBQVM1nC__xqlFyC5316Wx6dgd.YwhQwgHNNlReWprW
 XoGjIh1gXWTFiif4aUP6WbM8hYWOk6XYJRq6saIzrI2tHpHJapXnkraYCSNG
 8PXXTWpaZ12XzlQedWjonLCd1Ibw1v0cYi2PtaVV3FWI4ijvmJGbWrhzX6tO
 HFwzGM4u95fYjvIcnBj7xnnfHdiHXDyHqlNjjm0yMIiDDhogJju7z7NVR7Md
 a9RIPeGgzPNiu1JN61rIfFHBFrKssqZAMpXtLR1h9u3Bws1nm8AtbEld0PHz
 a.j.voUOxzpl_QTwDx.FV36Vc1OAaytZAll7JzNBcKGVTeQvIjeNJIfKYKuZ
 ocN6wzrP6GTtLIvJoD5mlep44M9K0bbFZNjp_C_I3rq_HncoQXtPy_Uij56n
 mI4S9lb7Q4X0gRDzZR34mVB6o4ugrpepq1UU-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 May 2012 10:56:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: remove unused argument of init_kmem_cache_node()
In-Reply-To: <1336665047-22205-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205101055510.18664@router.home>
References: <1336665047-22205-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Joonsoo Kim wrote:

> We don't use the argument since commit 3b89d7d881a1dbb4da158f7eb5d6b3ceefc72810
> ('slub: move min_partial to struct kmem_cache'), so remove it

Acked-by: Christoph Lameter <cl@linux.com>

