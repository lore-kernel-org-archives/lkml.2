Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0GVQEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0GVQEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:04:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20204.1279812793@redhat.com>
References: <20204.1279812793@redhat.com> <20100722145738.GA5752@amd> <20100722041554.GB3446@amd> <27282.1279058150@redhat.com> <30811.1279802187@redhat.com>
Cc: dhowells@redhat.com, Nick Piggin <npiggin@suse.de>,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Add a dentry op to handle automounting rather than abusing follow_link
Date: Thu, 22 Jul 2010 17:04:01 +0100
Message-ID: <20659.1279814641@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> But why would you want to delegate mountpoint traversal to the filesystem?

s/mountpoint traversal/mounted filesystem iteration/

David
