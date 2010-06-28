Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0F1NY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0F1NYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:24:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C289B39.4060901@suse.de>
References: <4C289B39.4060901@suse.de> <22746.1277470713@redhat.com> <4C24A4A0.90408@suse.de> <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com> <23204.1277472412@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Mon, 28 Jun 2010 14:24:45 +0100
Message-ID: <9513.1277731485@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Did you mean we need to validate differently for different servers?

You may need to, yes, as different servers may make different attributes
available.

This isn't too bad.  Each server index record in the cache has freeform
auxiliary data, just as does each file data record.  You could, say, stick a
byte at the front that indicates what you've stored in there.

David
