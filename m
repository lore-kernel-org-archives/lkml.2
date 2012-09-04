Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2IDWwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab2IDWwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:52:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
References: <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com> <20120816013405.872.42381.stgit@warthog.procyon.org.uk> <87627ufi2h.fsf@rustcorp.com.au>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] module: signature infrastructure
Date: Tue, 04 Sep 2012 23:51:38 +0100
Message-ID: <19214.1346799098@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:

> Or let the magic string as the last thing in the module and store the
> signature length, too. In this case no scanning is needed

Indeed.  This is the better way.

The main problem is rendering the length from a shell script.  It's trivial to
do as ASCII (there's a printf program), but a pain to render to binary.  I'm
sure it can be done with perl or python without the need to compile anything.

David
