Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2DJKsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:48:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51009 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2DJKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <m162dctjbo.fsf_-_@fess.ebiederm.org>
References: <1333664446.3538.12.camel@lappy> <m1aa2pwxap.fsf@fess.ebiederm.org>
 <CA+1xoqdi4QOhRJvBA64pxiN3EphhThjPkf4eLRkYM8jxcJjh=w@mail.gmail.com>
 <m1mx6otk85.fsf@fess.ebiederm.org> <m1aa2otjf4.fsf_-_@fess.ebiederm.org> <m162dctjbo.fsf_-_@fess.ebiederm.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 10 Apr 2012 12:47:32 +0200
Message-ID: <CA+1xoqc6-iPuB0rVZ05uM1DBPkR5ZvATTMeDdMmHw0SqFjY+GA@mail.gmail.com>
Subject: Re: [PATCH 2/2] phonet: Sort out initiailziation and cleanup code.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Remi Denis-Courmont <remi.denis-courmont@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 3:35 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Recently an oops was reported in phonet if there was a failure during
> network namespace creation.
>

Looks like these two patches fix the problem I've reported.
