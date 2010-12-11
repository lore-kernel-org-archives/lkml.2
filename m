Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0LKAv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:51:27 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:59939 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0LKAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qzh5DhG/VjqGa/LVZXlIbpnBtlusZVIZOUmSzFLeJ89oNqn5GqglxCyj2e8Nrvpl68
         yNeu5aFlOCp7NiY6QQUz3/kPpLvKHkviBnElkFm0lxCIYz8MgdzjoMcu+bA6LZw1Rc72
         HXcB3BOSBTMLBv0Yl1m41gd+Unx4pAvyLihHA=
Date: Sat, 11 Dec 2010 02:50:44 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 1/4] Add a user_namespace as creator/owner of
 uts_namespace
Message-ID: <20101211005044.GA25513@p183.telecom.by>
References: <20101209172027.GA10085@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209172027.GA10085@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 05:20:27PM +0000, Serge E. Hallyn wrote:
>  struct uts_namespace {
>  	struct kref kref;
>  	struct new_utsname name;
> +	struct user_namespace *user_ns;

You're going to add these to the rest?
