Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0DUES4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 00:18:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55108 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0DUESy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 00:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=leq4+MpUpZouakj9abT9VeRrmG73lfSJBB04pxFtH5FfkEMZNkLX5okDJuVDgQTHcY
         wpU0sIx8Vbbg8VKNcW39XjxxNzpPQs8eVQyOzKflyjXj93mkr4HheqlHpqcHXGYJ1Q8U
         271DtZ5usgX18s70pOepTrWcr/GWgCIUOf+Cw=
MIME-Version: 1.0
In-Reply-To: <20100421034532.GA9254@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
	 <20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	 <20100421034532.GA9254@us.ibm.com>
Date: Tue, 20 Apr 2010 21:18:53 -0700
Message-ID: <h2na67e66b21004202118w484dd8f0pe526b0a1fc7220e0@mail.gmail.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
From: Ashwin Ganti <ashwin.ganti@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 8:45 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Greg KH (greg@kroah.com):
>> Hm, who is going to maintain this, you, or Ashwin?
>
> I haven't asked Ashwin, and will be happy either way.  Ashwin, did
> you want to maintain it?

Well, since you have been driving a lot of implementation changes
recently, I feel it makes sense for you to be a maintainer. Honestly I
don't think I will be able to find time maintaining this in the future
although I can do the code reviews for you. I will be more than happy
if this feature continues to get traction.

- Ashwin
