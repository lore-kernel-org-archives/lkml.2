Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab0EDOod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:44:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793Ab0EDOoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:44:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-s390@vger.kernel.org, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Matt Helsley <matthltc@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate pidmap page
Date: Tue, 04 May 2010 15:43:13 +0100
Message-ID: <3803.1272984193@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With a huge patch series like this, can you post a cover note at the front
(usually patch 0) saying what the point of the whole series is?

David
