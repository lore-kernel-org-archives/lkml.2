Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1BXRDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1BXRDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:03:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110224150150.GA8262@mail.hallyn.com>
References: <20110224150150.GA8262@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@osdl.org>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, oleg@mail.hallyn.com,
        dlezcano@mail.hallyn.com, LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/10] Add a user_namespace as creator/owner of uts_namespace
Date: Thu, 24 Feb 2011 17:03:11 +0000
Message-ID: <27931.1298566991@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Feel free to add my Acked-by to these patches, give or take the correction to
the change description of the 5th patch.

David
