Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1BAWCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:02:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab1BAWCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:02:42 -0500
Date: Tue, 1 Feb 2011 16:28:02 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/4] Fix error handling in hfsplus mount failure paths
Message-ID: <20110201162802.2dd07201@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus can generate NULL pointer exceptions when a user attempts
to mount an invalid filesystem. In some paths it also leaks memory.

This series attempts to fix some of the most obvious problems.
