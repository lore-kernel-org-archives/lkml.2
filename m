Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2IUR4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:56:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2IUR4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:56:40 -0400
Message-ID: <505CAA4F.70801@canonical.com>
Date: Fri, 21 Sep 2012 10:56:31 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 07:22 PM, James Morris wrote:
> On Thu, 20 Sep 2012, Kees Cook wrote:
> 
>> Earlier proposals for appending signatures to kernel modules would not be
>> useful in Chrome OS, since it would involve adding an additional set of
>> keys to our kernel and builds for no good reason: we already trust the
>> contents of our root filesystem. We don't need to verify those kernel
>> modules a second time. Having to do signature checking on module loading
>> would slow us down and be redundant. All we need to know is where a
>> module is coming from so we can say yes/no to loading it.
> 
> Just out of interest, has anyone else expressed interest in using this 
> feature?
> 
we are looking at using it in apparmor as well

