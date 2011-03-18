Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1CRJYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:24:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab1CRJYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=JBHJUiBg8obEUxOM/wg5vNP3XPKvFKM8E2rCys3mLA54KmvpbUgRGQANcdKSTnZs5R
         iiYoFoy7g7fp7yAosv8w==
MIME-Version: 1.0
In-Reply-To: <20110318071238.GW2008@bicker>
References: <20110318071238.GW2008@bicker>
From: Mike Waychison <mikew@google.com>
Date: Fri, 18 Mar 2011 02:24:18 -0700
Message-ID: <AANLkTi=HYEN16eSS1LqFcY-TO6=K=QzrrmDABXL48KpE@mail.gmail.com>
Subject: Re: [patch 2/2] efivars: handle errors from register_efivars()
To: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Waychison <mikew@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:12 AM, Dan Carpenter <error27@gmail.com> wrote:
> We should unwind and return an error if register_efivars() fails.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mike Waychison <mikew@google.com>
