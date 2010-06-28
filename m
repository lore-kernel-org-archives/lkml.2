Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0F1MjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0F1MjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:39:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277621246-10960-2-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-2-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, sds@tycho.nsa.gov,
       lenb@kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/5]security:key.c Fix warning: variable 'key' set but not used 
Date: Mon, 28 Jun 2010 13:38:37 +0100
Message-ID: <5104.1277728717@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> In this case the safest approach(in my mind) would be to just
> mark the integer __unused. Keep in mind though Im not certain 
> if this is the right place for this value i.e. will this effect
> *instkey or not(please check).

This is the wrong approach.  Either the variable should be got rid of, or it
should be used to replace all the other calls to key_ref_to_ptr() in
keyctl_describe_key().

David
