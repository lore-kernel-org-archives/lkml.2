Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1HJR5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:57:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35899 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab1HJR5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:57:50 -0400
Message-ID: <4E42C5B8.3060709@zytor.com>
Date: Wed, 10 Aug 2011 12:54:00 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org> <1312067670.22074.61.camel@i7.infradead.org> <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com> <4E34998D.8060806@zytor.com> <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com> <4E4140B3.7090802@suse.cz> <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com> <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org> <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com> <1312985888.2989.46.camel@i7.infradead.org> <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com> <1312993987.2989.53.camel@i7.infradead.org> <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
In-Reply-To: <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 12:44 PM, Arnaud Lacombe wrote:
> Exactly my point, you just successfully created an half-backed config
> which is different than what Aunt Tillie wanted you to generate. This
> should be an hard error, same for "all*.config", not to mention that
> the error message is far from being helpful.

Arnaud,

This is arguably a bug in how config fragments are injected via any
mechanism, but that is completely orthogonal to us wanting another
injection mechanism.

	-hpa

