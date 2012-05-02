Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2EBRNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:13:25 -0400
Received: from flusers.ccur.com ([173.221.59.2]:58257 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753983Ab2EBRNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:13:24 -0400
Date: Wed, 2 May 2012 13:13:18 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch: kstrtol fix
Message-ID: <20120502171318.GA2103@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20120502151046.GA25594@tsunami.ccur.com>
 <1335975202.2324.12.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335975202.2324.12.camel@groeck-laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 12:13:22PM -0400, Guenter Roeck wrote:
> On Wed, 2012-05-02 at 11:10 -0400, Joe Korty wrote:
>> kstrtol is a substitute for simple_strtol() only when when second
>> arg of simple_strtol() is NULL. For any other value the functionality
>> of simple_strtol() cannot be implemented in terms of kstrtol.
> 
> If there _are_ uses of
> simple_strtol() where the second argument is not used for error checking
> but for some other purpose, I am sure that an alternative solution can
> be found which does not require simple_strtol(). Or just live with the
> warning for those cases.
> 
> Thanks,
> Guenter

And of course the burning question is, what was the compelling reason
kstrtol wasn't made upwards-compatible with strtol?  It just seems
gratituous to have that little bit of incompatibility introduced
into the kernel.

Joe

