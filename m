Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0CZRQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:16:28 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:34777 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0CZRQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:organization
         :user-agent:x-os;
        b=qPSrnVFuw/qW8hplgzAGMEk+dC3TYceN5EKsjiw5QhQ+6zNKqGlGopq0LzNeu8xInJ
         YMEIH8cSLXnk+tGYVocc530L/9xfzEkKsHJQtKrWvYks2bMMUv7znIeQPpCE2buTbrkI
         1suWH8gz4vChpZBUvjWjEiVzqeHFk37LHtRNU=
Date: Fri, 26 Mar 2010 22:46:18 +0530
From: Ajit Khaparde <ajitkhaparde@gmail.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-drivers@serverengines.com, sathyap@serverengines.com
Subject: Re: [PATCH] benet: Fix compile warnnings in
 drivers/net/benet/be_ethtool.c
Message-ID: <20100326171616.GA20879@serverengines.com>
Reply-To: Ajit Khaparde <ajitk@serverengines.com>
References: <20100326061259.GB30341@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326061259.GB30341@localhost.localdomain>
X-URL: http://www.serverengines.com
Organization: ServerEngines Corp
User-Agent: "Ajit's Mutt"
X-OS: Linux x86_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/10 14:12 +0800, wzt.wzt@gmail.com wrote:
> Fix the following warnings:
> 
> be_ethtool.c:493: warning: integer constant is too large for 'long' type
> be_ethtool.c:493: warning: integer constant is too large for 'long' type
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

I would suggest using be2net instead of benet during the commit. 
be2net: Fix compile warnnings in drivers/net/benet/be_ethtool.c

Acked-by: Ajit Khaparde <ajitk@serverengines.com>
