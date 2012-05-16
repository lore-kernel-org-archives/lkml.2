Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab2EPGYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:24:19 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38963 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757467Ab2EPGYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:24:17 -0400
Subject: Re: NVM Mapping API
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120515133450.GD22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 May 2012 10:24:13 +0400
Message-ID: <1337149453.1961.24.camel@slavad-ubuntu-11>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.10.70 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
> There are a number of interesting non-volatile memory (NVM) technologies
> being developed.  Some of them promise DRAM-comparable latencies and
> bandwidths.  At Intel, we've been thinking about various ways to present
> those to software.

Could you please share vision of these NVM technologies in more details?
What capacity in bytes of of one NVM unit do we can expect? What about
bad blocks and any other reliability issues of such NVM technologies?

I think that some more deep understanding of this can give possibility
to imagine more deeply possible niche of such NVM units in future memory
subsystem architecture.

With the best regards,
Vyacheslav Dubeyko.

