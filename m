Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1GLVTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:19:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1GLVTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:19:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bCMz7/wx+/0yl25JHGKfF/DoDDUbtIs2F+gGHgDVJStfildTsOiAKQxsZmWUI2SqW
	NzvOwgB9M/xpsmg/2p+Hw==
MIME-Version: 1.0
In-Reply-To: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Tue, 12 Jul 2011 14:19:09 -0700
X-Google-Sender-Auth: GSDKbmp8YVp7usITti8wF3JUVnw
Message-ID: <CAPz6YkWU-CtUP-dNVKjp8qw87gBoLjJ5fCQ5g+OzKa5yhLcn=g@mail.gmail.com>
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
To: acme@redhat.com
Cc: anton@samba.org, rostedt@goodmis.org, Sonny Rao <sonnyrao@chromium.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 2:15 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
> While attempting to create a timechart of boot up I found
> perf didn't tolerate modules being loaded/unloaded.  This patch
> fixes this by reading the file once and then writing the size
> read at the correct point in the file.  It also simplifies the
> code somewhat.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---

Anton or Paul, I cc'ed you hoping you could give this a try on a
big-endian box.  There's some IMO less than pleasant code to
make sure it handles big-endian correctly, that I wasn't able to test.

Thanks
Sonny
