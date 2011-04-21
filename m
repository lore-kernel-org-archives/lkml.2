Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1DUVDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:03:03 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:65306 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428Ab1DUVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:03:01 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 17:03:00 EDT
X-AuditID: 1209190e-b7c80ae0000047dd-ef-4db09a5e1004
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
Date: Thu, 21 Apr 2011 16:45:54 -0400
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsUixG6nrhs3a4OvwcQDchanJyxisph1eQqb
	xaXHK9gt9uw9yWJxedccNgdWj80rtDze77vK5vF5k1wAcxSXTUpqTmZZapG+XQJXxpTrlxkL
	NjJWnN/Qz9LA2MDYxcjJISFgInFj2mUmCFtM4sK99WxdjFwcQgL7GCW+H/3ADuFsYJR4s/8L
	lLOSSaLj4TxmkBZhATuJZVt3soDYvAKGEks3tbOD2MwCWhI3/r0EG8smoCRx59N+sBpOAQeJ
	03++sYHYLAKqEhN/TGCGqK+Q2PT6DhOELS+x/e0cZoiZVhJnZq5jBbGFBOwleta8BJsjAjTz
	1PFvQDYH0NmyEk3LMiYwCs5CcsUsJFfMQjJ1ASPzKkbZlNwq3dzEzJzi1GTd4uTEvLzUIl1j
	vdzMEr3UlNJNjKAg55Tk28H49aDSIUYBDkYlHt7nsRt8hVgTy4orcw8xSnIwKYnyRs4ECvEl
	5adUZiQWZ8QXleakFh9ilOBgVhLhXdsElONNSaysSi3Kh0lJc7AoifPOlFT3FRJITyxJzU5N
	LUgtgsnKcHAoSfCeBhkqWJSanlqRlplTgpBm4uAEGc4DNHwnSA1vcUFibnFmOkT+FKMxx+FD
	M/YzcjR1zd7PKMSSl5+XKiXOewekVACkNKM0D24aLFG9YhQHek6Ydx9IFQ8wycHNewW0iglo
	1dIr60FWlSQipKQaGBXY561rFXnwean/6m+7N7Ju8NX+p3hU9VGTVcCjQ7wyLyI5gxYv4u1e
	U/RWxuUCf0Tm3ia/jISYxX9l2cI0Hl/nX3WsP2benpcxB8OiUyf4S+ZbbOpeKPtXwXf37Wlp
	N66YeWpue7TJxe7AsfeWQrpNJrlFAX99z5TrTz3Vte/KyvfHVznIr1ZiKc5INNRiLipOBAB4
	d7cZLwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 21, 2011, at 3:42 PM, Josef Bacik wrote:

> +	case SEEK_DATA:
> +	case SEEK_HOLE:
> +		return -EINVAL;
> 	}

Maybe we should be returning EOPNOTSUPP?

-- Ted

