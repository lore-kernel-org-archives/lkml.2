Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab1LBSmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1LBSmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:42:50 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/21] MPILIB: Export some more symbols [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:42:42 +0000
Message-ID: <20111202184242.21874.85767.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export some more symbols for use by the DSA key subtype.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/mpi/mpi-cmp.c  |    2 ++
 lib/mpi/mpi-div.c  |    1 +
 lib/mpi/mpi-inv.c  |    1 +
 lib/mpi/mpi-mpow.c |    1 +
 lib/mpi/mpi-mul.c  |    1 +
 5 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
index 914bc42..1871e7b 100644
--- a/lib/mpi/mpi-cmp.c
+++ b/lib/mpi/mpi-cmp.c
@@ -39,6 +39,7 @@ int mpi_cmp_ui(MPI u, unsigned long v)
 	else
 		return -1;
 }
+EXPORT_SYMBOL_GPL(mpi_cmp_ui);
 
 int mpi_cmp(MPI u, MPI v)
 {
@@ -66,3 +67,4 @@ int mpi_cmp(MPI u, MPI v)
 		return 1;
 	return -1;
 }
+EXPORT_SYMBOL_GPL(mpi_cmp);
diff --git a/lib/mpi/mpi-div.c b/lib/mpi/mpi-div.c
index c3087d1..3da9402 100644
--- a/lib/mpi/mpi-div.c
+++ b/lib/mpi/mpi-div.c
@@ -59,6 +59,7 @@ nomem:
 		mpi_free(temp_divisor);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(mpi_fdiv_r);
 
 /****************
  * Division rounding the quotient towards -infinity.
diff --git a/lib/mpi/mpi-inv.c b/lib/mpi/mpi-inv.c
index 0951f98..bfc5ca1 100644
--- a/lib/mpi/mpi-inv.c
+++ b/lib/mpi/mpi-inv.c
@@ -185,3 +185,4 @@ cleanup:
 	mpi_free(v);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(mpi_invm);
diff --git a/lib/mpi/mpi-mpow.c b/lib/mpi/mpi-mpow.c
index 4cc7593..5752194 100644
--- a/lib/mpi/mpi-mpow.c
+++ b/lib/mpi/mpi-mpow.c
@@ -131,3 +131,4 @@ nomem:
 	kfree(G);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(mpi_mulpowm);
diff --git a/lib/mpi/mpi-mul.c b/lib/mpi/mpi-mul.c
index 1f3219e..3d514b9 100644
--- a/lib/mpi/mpi-mul.c
+++ b/lib/mpi/mpi-mul.c
@@ -192,3 +192,4 @@ int mpi_mulm(MPI w, MPI u, MPI v, MPI m)
 		return -ENOMEM;
 	return mpi_fdiv_r(w, w, m);
 }
+EXPORT_SYMBOL_GPL(mpi_mulm);

