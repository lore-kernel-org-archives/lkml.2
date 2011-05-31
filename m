Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1EaPWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:22:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49360 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaPWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qG8lNQHEafBYeaU+313JS7du9AmdY7RmaN6iDsBDozrD10AXWaiIc96boYm0nyNsxG
         adGMTr8SjWweez9zx0SDaOmmHA7dYjwLSjWOQZj8dAORK6YSWcElS3WMBWi4khR51AhX
         3eichvcjkypYBd8xtTZD8ytAS02RhZcOcfPmA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikPqkDON4mzBEko46JdgACrbTOiiA@mail.gmail.com>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
	<BANLkTinu7dX5Tfhs0ak0BEfc212mpJKb+w@mail.gmail.com>
	<BANLkTikPqkDON4mzBEko46JdgACrbTOiiA@mail.gmail.com>
Date: Tue, 31 May 2011 11:22:39 -0400
Message-ID: <BANLkTi=_8nSWYt=7+EgoORiYHqpRhOQurw@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix-up free space earlier in mount_ubifs()
From: "Matthew L. Creech" <mlcreech@gmail.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:52 AM, Ben Gardiner
<bengardiner@nanometrics.ca> wrote:
>
> Thank you for your endorsement. Can we take that as a Reviewed-by ?
>

Sure, looks good to me:

Reviewed-by: Matthew L. Creech <mlcreech@gmail.com>

-- 
Matthew L. Creech
