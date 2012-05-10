Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2EJXjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:39:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab2EJXj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:39:28 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/29] MPILIB: Export some more symbols [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:39:12 +0100
Message-ID: <20120510233912.4137.93313.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
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
index f68cbbb..fed3405 100644
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
index 7328d0d..b8b22e5 100644
--- a/lib/mpi/mpi-mpow.c
+++ b/lib/mpi/mpi-mpow.c
@@ -132,3 +132,4 @@ nomem:
 err_out:
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

