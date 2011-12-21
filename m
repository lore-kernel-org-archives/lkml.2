Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1LUVcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1LUVcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:32:07 -0500
Date: Wed, 21 Dec 2011 16:32:01 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com, Bart Van Assche <bvanassche@acm.org>
Cc: jim.cromie@gmail.com, joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] dynamic_debug: add trim_prefix() to provide
 source-root relative paths
Message-ID: <20111221213200.GB30393@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
 <2de3288bd94ae76c7a7d7486b94e2e59e5ca97a8.1324318997.git.jbaron@redhat.com>
 <CAO+b5-od4CFkJkxQKoXq4e85XeKq9VFX2kh5FbT7_JMSgFX=JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO+b5-od4CFkJkxQKoXq4e85XeKq9VFX2kh5FbT7_JMSgFX=JQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 08:15:55AM +0000, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 10:13 PM, Jason Baron <jbaron@redhat.com> wrote:
> > +/* Return the path relative to source root */
> > +static inline const char *trim_prefix(const char *path)
> > +{
> > +       int skip = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
> > +
> > +       if (strncmp(path, __FILE__, skip))
> > +               skip = 0; /* prefix mismatch, don't skip */
> > +
> > +       return path + skip;
> > +}
> 
> Isn't the preferred style to write if (strncmp(...) != 0) ..., i.e. to
> mention "!= 0" explicitly instead of leaving it out when comparing
> strings ?
> 
> Bart.

Greg,

Again, no functional change here, just a style thing. Let me know if you
want a re-post. I am fine with it as-is.

Thanks,

-Jason
