Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1EKR1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab1EKR1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:27:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Valerie Aurora <valerie.aurora@gmail.com>, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com
Subject: Unionmount fallthru directory entries
Date: Wed, 11 May 2011 18:00:19 +0100
Message-ID: <30230.1305133219@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What are unionmount fallthru directory entries for and why are they needed?

I'm guess that what they do is indicate that the dirent in question must be
looked up in the corresponding directory on the underlying fs.

As to why they are needed, am I right in thinking that unionmount caches a
copy of all the lower directory's entries in the upper directory with fallthru
markers set on the first call to readdir?

David
