Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab0KLSVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:21:04 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:56613 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KLSVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:21:03 -0500
Subject: [PATCH 0/2] sysfs: Introducing group functions for binary sysfs
 attributes
From: Stefan Achatz <stefan_achatz@web.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 19:18:35 +0100
Message-ID: <1289585915.2629.11.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ULyiAlyRleHIoAabmQCr+o31GcAvYXva7HWmG
	lSIOBTfAC1uGknkMhPyxm7LHYRG2TRwR1M1G+33ipdaeBacBFi
	VIxbffn1K5PiRdIVgUXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov asked me to implement group functions for sysfs binary
attributes.
This patchset includes my first proposal and changes on my kone mouse
hid driver that uses part of the new functions.

