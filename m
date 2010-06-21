Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab0FUUki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:40:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab0FUUj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:39:57 -0400
Date: Mon, 21 Jun 2010 16:31:46 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       aarcange@redhat.com, linux-mm@kvack.org
Subject: [PATCH 0/6] further anon_vma fixes & optimizations
Message-ID: <20100621163146.4e4e30cb@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A collection of anon_vma fixes and optimizations from Andrea's
transparent hugepage tree.

-- 
All rights reversed.
