Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1BCSNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:13:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32764 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab1BCSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OFKDyXXeiPMlXRLXnqz7jH/PITW9ZdHeapz2aDsr6H7B6TUzRf5P6ia6FGPZ0DTouR
         ushNeETG7cWjd7g968pw==
MIME-Version: 1.0
In-Reply-To: <20110203095117.76a568fc@putvin>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name> <20110202145605.6c9006fa@putvin>
 <20110203092229.GB1083@shutemov.name> <20110203095117.76a568fc@putvin>
From: Paul Menage <menage@google.com>
Date: Thu, 3 Feb 2011 10:12:51 -0800
Message-ID: <AANLkTikvkUT8+U=bX6X2n7kMbnAt6evxTy1BqiX+TWpH@mail.gmail.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 9:51 AM, Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:
>
> I think this logic defeats the purpose of having timer_slack
> subsystem in the first place. IMHO, the original intention was to have
> grouping effect of tasks in the cgroup.

You can get the semantics you want by just setting min_slack_ns = max_slack_ns.

Paul
