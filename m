Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1CRJXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:23:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5839 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1CRJX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=a+YI3O5x21E+ICSyA8374rMcfr/ib7GhnaOCDMHUkVNjSelkSvWD9vzvvi+dTi1P6l
         ZuVmfvYSxy5Z308CWhOg==
MIME-Version: 1.0
In-Reply-To: <20110318071214.GV2008@bicker>
References: <20110318071214.GV2008@bicker>
From: Mike Waychison <mikew@google.com>
Date: Fri, 18 Mar 2011 02:23:00 -0700
Message-ID: <AANLkTim7uAt_TR9XCZkPBDo7VwfNqvFSguKYndzyw0P7@mail.gmail.com>
Subject: Re: [patch 1/2] efivars: memory leak on error in create_efivars_bin_attributes()
To: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Waychison <mikew@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:12 AM, Dan Carpenter <error27@gmail.com> wrote:
> This is a cut and paste bug.  We intended to free ->del_var and
> ->new_var but we only free ->new_var.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mike Waychison <mikew@google.com>
