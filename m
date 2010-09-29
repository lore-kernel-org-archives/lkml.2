Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0I2MSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:18:14 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:30630 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751427Ab0I2MSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:18:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Afv9IOwVM1m3oA7p9k.sG.AfPbQLLYlEPgwEEyRd5rCLPhC
 EQd18u0TluSMkZkFzekHdhLP0j1AA7UPYGlSopGlC5bdNIIbe7TRlBqr8WDF
 PCCw6tALvkH83J9Rmz7.Yllm7CmItHzeC9Z.N_fSahbZjOeApynG5JnsRKzw
 aEIUsI1OTdklQM0BM9xTlQ3UMCbfD2cQahmurC.RZGSFtpGPR5ik401Ve83I
 m6SXPx5JIVzayT8M7CwfWXndoKn7iNYvC0leh4iNADjyX4BXenw3IyNouaZI
 l
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 29 Sep 2010 07:18:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Namhyung Kim <namhyung@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slub: Fix signedness warnings
In-Reply-To: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.DEB.2.00.1009290717230.30155@router.home>
References: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010, Namhyung Kim wrote:

> The bit-ops routines require its arg to be a pointer to unsigned long.
> This leads sparse to complain about different signedness as follows:

Acked-by: Christoph Lameter <cl@linux.com>

