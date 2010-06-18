Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221Ab0FRNTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:19:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53615 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab0FRNTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BCtMY1dljJNlU5xbHMXn0hrk8pK4JtzTYh5mWZ0uxsXFrIGoDM69PGLpTRi0XnbtTH
         OeHzWYtveUGASO/nu19tTky0CL8xCP163iv6af0DscBXm6sm305/Gj4abiLleNpsgPBX
         6OX6vBpYY+/VLN/fExZD5dkofNNDWKde7ADsY=
MIME-Version: 1.0
In-Reply-To: <AANLkTilrWSOoias64UGAnkV1RtIkVKiwapCnOYc2cS0_@mail.gmail.com>
References: <1276806411-15176-1-git-send-email-scottjg@vmware.com>
	<AANLkTilrWSOoias64UGAnkV1RtIkVKiwapCnOYc2cS0_@mail.gmail.com>
Date: Fri, 18 Jun 2010 14:19:36 +0100
X-Google-Sender-Auth: SEQYQZrMLR8mFedFoOSyq6QGtHs
Message-ID: <AANLkTinhcJAphiOo6Gj3pl7NY2oGkAwEw3xJZY_nvOxw@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: fix false positive on casting to double 
	pointer
From: Andy Whitcroft <apw@canonical.com>
To: "Scott J. Goldman" <scottjg@vmware.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hrm, I would expect any number of levels of pointers to be detected
> already correctly.
>
> /me goes check.

We already have tests for both types which are passing generally, in
t730-* and t7020-* so I think this is more likely a failure to detect
the type as a type.  If you could send on the sample that triggers
this I will have a look.

-apw
